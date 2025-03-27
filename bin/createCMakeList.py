#!/usr/bin/env python
import argparse
from jinja2 import Environment, FileSystemLoader
from datetime import datetime
import os


def parse_args() -> dict:
    parser = argparse.ArgumentParser(
        prog="cmake", description="cmake helper", epilog="2022 - adenTech"
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-p",
        "--project",
        type=str,
        help="Name of the project (executable will have same name)",
    )
    group.add_argument(
        "-b",
        "--build",
        default=False,
        action="store_true",
        help="create build dir and compile project)",
    )
    group.add_argument(
        "-c", "--clean", default=False, action="store_true", help="clean build dir"
    )
    parser.add_argument(
        "-l",
        "--libs",
        nargs="+",
        choices=[
            "all",
            "cli11",
            "doctest",
            "eigen",
            "fmt",
            "highfive",
            "linenoise",
            "plog",
            "rapidcsv",
        ],
        help="libraries to include. options (all, cli11, doctest, eigen, fmt, highfive, linenoise, plog, rapidcsv)",
    )

    tmpl_args = {}
    args = parser.parse_args()
    if args.project:
        tmpl_args = {"project": args.project}
    elif args.build:
        os.system(
            "rm -rf build && mkdir build && cd build && cmake -GNinja .. && ninja && cp compile_commands.json .."
        )
    elif args.clean:
        os.system("rm -rf build")

    if args.libs:
        if "all" in args.libs:
            items = [
                "fmt",
                "doctest",
                "highfive",
                "cli11",
                "plog",
                "eigen",
                "linenoise",
                "rapidcsv",
            ]
        else:
            items = args.libs

        for item in items:
            tmpl_args[item] = True

    return tmpl_args


def write_cmk_list(tmpl_args):
    if tmpl_args:
        now = datetime.now()
        # current_time = now.strftime("%H:%M:%S")
        current_time = now.ctime()

        tmpl_args["time"] = current_time

        environment = Environment(loader=FileSystemLoader("/home/ajish/bin/templates/"))
        template = environment.get_template("cmakelist.jinja")
        # cmk_opts = template.render({'project':args.project})
        cmk_opts = template.render(tmpl_args)

        with open("./CMakeLists.txt", mode="w") as cmk_lst_template:
            cmk_lst_template.write(cmk_opts)
            print("...Wrote CMakeLists.txt")


def main():
    write_cmk_list(parse_args())


if __name__ == "__main__":
    main()
