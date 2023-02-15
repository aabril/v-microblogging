module main

import os
import markdown

struct Cache {
    markdown_files []string
    mut: markdown_renders map[string]string
}

fn (c &Cache) renders() {
    // c.markdown_renders = c.markdown_files.map[string]string{
    // mut m := c.markdown_files.map(k, v)
    // println(m)
    // for i, s in c.markdown_renders {
    //     c.markdown_renders[s] = "hey ${i}"
    // }

    for file in c.markdown_files {
        mut mdtext := os.read_file(file) or { panic(err) }
        c.markdown_renders["hola"] = markdown.to_html(mdtext)
        // println(markdown.to_html((mdtext)))
        // c.markdown_renders[file] := markdown.to_html(mdtext)
    }

}

fn reset_dist_folder() {
    dist_path := "./dist/"
    println('Reset ${dist_path} folder')
    os.rmdir_all(dist_path) or { println(err) return }
    os.mkdir(dist_path) or { println(err) return }
}

fn main() {
    
    reset_dist_folder()

    mut cache := Cache{
        markdown_files: os.walk_ext("./files/", ".md")
    }
    println(cache)
    cache.renders()
    println(cache)

}
