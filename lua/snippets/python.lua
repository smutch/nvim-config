return {
    s({ trig = "ifmain", name = "if __main__", descr = "If this is being run directly" },
        t({ 'if __name__ == "__main__":', "    " }), i(0)
    ),

    s(
        {
            trig = "script",
            name = "script template",
            descr = "A scaffold for a script"
        },
        {
            t({
                'from pathlib import Path',
                '',
                'import typer',
                '',
                '',
                'def main():',
                "    "
            }), i(0),
            t({
                '',
                '',
                '',
                'if __name__ == "__main__":',
                "    typer.run(main)"
            })
        }
    ),
}
