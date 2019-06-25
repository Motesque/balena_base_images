from jinja2 import Environment, FileSystemLoader
import argparse
import sys
import yaml

def render(template_fn, platform):
    jinja_env = Environment(
        loader=FileSystemLoader("."),
        trim_blocks=True,
        lstrip_blocks=True
    )
    if platform not in ["amd64", "raspberrypi3", "imx8m-var-dart"]:
        raise ValueError(f"unsupported platform {platform}")
    # check whether we have a valid jinja template
    with open(template_fn, "r") as fp:
        if "{%" not in fp.read():
            raise ValueError("Input file is not a jira template")

    cross_build = platform != "amd64"
    sys.stderr.write(f"Configuring for platform={platform}, cross_build={cross_build}\n")
    file_template = jinja_env.get_template(template_fn)
    print(f"# Autogenerated: platform={platform}, cross_build={cross_build}")
    dockerfile_str = file_template.render(platform=platform, cross_build=cross_build)
    print(dockerfile_str)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Configure different Dockerfile variants for balena.')
    parser.add_argument('FILE', type=str,
                        help='The docker file jinja2 template file to process')
    parser.add_argument('--platform', action='store', required=True,
                        help="The balena platform to use. (raspberrypi3|imx8m-var-dart|amd64)")
    args = parser.parse_args()
    try:
        render(template_fn=args.FILE, platform=args.platform)
    except Exception as err:
        sys.stderr.write(f"ERROR Cannot create docker-compose.yml! error='{err}'\n")
