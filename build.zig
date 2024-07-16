const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const version = std.SemanticVersion{ .major = 4, .minor = 4, .patch = 1 };

    // Custom options
    const use_curl = b.option(bool, "use-curl", "Enable remote file access") orelse false;
    const use_bz2 = b.option(bool, "use-bz2", "Enable reading bzip2-compressed files") orelse false;

    // Dependencies
    const cfitsio_dep = b.dependency("cfitsio", .{});
    const cfitsio_path = cfitsio_dep.path("");

    // Library
    const lib_step = b.step("lib", "Install library");

    const lib = b.addStaticLibrary(.{
        .name = "cfitsio",
        .target = target,
        .version = version,
        .optimize = optimize,
    });

    var flags = std.BoundedArray([]const u8, 4){};
    flags.appendSliceAssumeCapacity(&FLAGS);
    if (use_curl) {
        lib.linkSystemLibrary("curl");
        flags.appendAssumeCapacity("-DCFITSIO_HAVE_CURL");
    }
    if (use_bz2) {
        lib.linkSystemLibrary("bz2");
        flags.appendAssumeCapacity("-DHAVE_BZIP2=1");
    }

    lib.addCSourceFiles(.{ .root = cfitsio_path, .files = &SOURCES, .flags = flags.constSlice() });
    lib.installHeadersDirectory(cfitsio_path, "", .{ .include_extensions = &HEADERS });
    lib.linkSystemLibrary("z");
    lib.linkLibC();

    const lib_install = b.addInstallArtifact(lib, .{});
    lib_step.dependOn(&lib_install.step);
    b.default_step.dependOn(lib_step);

    // Module
    const module = b.addModule("cfitsio", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/lib.zig"),
    });
    module.linkLibrary(lib);

    // Formatting checks
    const fmt_step = b.step("fmt", "Run formatting checks");

    const fmt = b.addFmt(.{
        .paths = &.{
            "build.zig",
        },
        .check = true,
    });
    fmt_step.dependOn(&fmt.step);
    b.default_step.dependOn(fmt_step);
}

const HEADERS = .{
    "fitsio.h",
    "fitsio2.h",
    "longnam.h",
    "drvrsmem.h",
    "cfortran.h",
    "f77_wrap.h",
    "region.h",
};

const SOURCES = .{
    "buffers.c",
    "cfileio.c",
    "checksum.c",
    "drvrfile.c",
    "drvrmem.c",
    "drvrnet.c",
    "drvrsmem.c",
    "editcol.c",
    "edithdu.c",
    "eval_l.c",
    "eval_y.c",
    "eval_f.c",
    "fitscore.c",
    "getcol.c",
    "getcolb.c",
    "getcold.c",
    "getcole.c",
    "getcoli.c",
    "getcolj.c",
    "getcolk.c",
    "getcoll.c",
    "getcols.c",
    "getcolsb.c",
    "getcoluk.c",
    "getcolui.c",
    "getcoluj.c",
    "getkey.c",
    "group.c",
    "grparser.c",
    "histo.c",
    "iraffits.c",
    "modkey.c",
    "putcol.c",
    "putcolb.c",
    "putcold.c",
    "putcole.c",
    "putcoli.c",
    "putcolj.c",
    "putcolk.c",
    "putcoluk.c",
    "putcoll.c",
    "putcols.c",
    "putcolsb.c",
    "putcolu.c",
    "putcolui.c",
    "putcoluj.c",
    "putkey.c",
    "region.c",
    "scalnull.c",
    "swapproc.c",
    "wcssub.c",
    "wcsutil.c",
    "imcompress.c",
    "quantize.c",
    "ricecomp.c",
    "pliocomp.c",
    "fits_hcompress.c",
    "fits_hdecompress.c",
    "simplerng.c",
    "zcompress.c",
    "zuncompress.c",
};

const FLAGS = .{
    "-std=gnu89",
    "-D_REENTRANT",
};
