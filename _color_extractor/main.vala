/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2015 by Simon Schneegans
//
// Extracts primary color from images and writes a css stylesheet
/////////////////////////////////////////////////////////////////////////

void main (string[] args) {

    if (args.length > 2 && args[1] != "" && args[2] != "") {

        try {
            string css = "$link-colors: (\n";
            css += "  color-fallback: #EA75FF,\n";
            string file = "";
            string directory = GLib.Environment.get_current_dir() + "/" + args[1];
            var d = Dir.open(directory);
            while ((file = d.read_name()) != null) {
                string path = Path.build_filename(directory, file);
                if (FileUtils.test(path, FileTest.IS_REGULAR)) {
                    var image = new Image.from_file(path);
                    var color = new Color.from_image(image);

                    css += "  color-" + file.substring(0, file.index_of(".")) + ": "
                        + color.to_hex_string() + ",\n";
                }
            }

            css = css.substring(0, css.length-2);
            css += "\n);";
            FileUtils.set_contents(GLib.Environment.get_current_dir() + "/" + args[2], css);
        } catch (Error e) {
            warning (e.message);
        }
    }
}
