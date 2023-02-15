module main

import os
import markdown

const path_src = "files"
const path_dest = "dist"

struct Cache {
    markdown_files []string
    mut: 
        markdown_renders map[string]string
}

fn (c &Cache) renders() map[string]string {
    mut renders := map[string]string
    for file in c.markdown_files {
        mut mdtext := os.read_file(file) or { panic(err) }
        renders[file] = markdown.to_html(mdtext)
    }
    return renders
}

fn reset_dist_folder() {
    println('Reset ./${path_dest}/ folder')
    if os.is_dir("./${path_dest}/") { os.rmdir_all("./${path_dest}/") or { panic(err) } }
    os.mkdir("./${path_dest}/") or { panic(err) }
}

fn build(html string) string {
    return $tmpl('./layout.html')
}

fn (c &Cache) write_files() {
    for k,v in c.markdown_renders {
        filedest := k.replace(".md", ".html").replace(path_src, path_dest)
        os.mkdir_all(os.dir(filedest)) or { println("write_files mkdir_all(): ${err}") return }
        os.write_file(filedest, build(v)) or { println("write_files write_file(): ${err}") return }
    }
}

fn main() {
    reset_dist_folder()
    mut cache := Cache{
        markdown_files: os.walk_ext("./${path_src}/", ".md")
        markdown_renders: {}
    }
    cache.markdown_renders = cache.renders()
    cache.write_files()
}
