return {
    s({ trig = "ifmain", name = "if __main__", descr = "If this is being run directly" },
        t({ 'if __name__ == "__main__":', "\t" }), i(0)
    )
}
