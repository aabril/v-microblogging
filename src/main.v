module main

import os
import markdown

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
    // println(renders)
    return renders
}

fn reset_dist_folder() {
    dist_path := "./dist/"
    println('Reset ${dist_path} folder')
    os.rmdir_all(dist_path) or { println(err) return }
    os.mkdir(dist_path) or {}
}

fn (c &Cache) write_files() {
    for k,v in c.markdown_renders {
        filedest := k.replace(".md", ".html").replace("\/files\/", "\/dist\/")
        pathdest := os.dir(filedest)

        println(" ")
        println("filedest ${filedest}")
        println("pathdest ${pathdest}")
        println("quoted_path ${os.quoted_path(pathdest)}")
        println(" ")

        os.mkdir_all(pathdest) or {println(err) return }
        // os.mkdir_all(filedest) or {println(err) return }
        os.write_file(filedest, v) or { println(err) return }
    }
}

fn main() {
    
    reset_dist_folder()

    mut cache := Cache{
        markdown_files: os.walk_ext("./files/", ".md")
        markdown_renders: {}
    }
    cache.markdown_renders = cache.renders()
    println(cache)
    cache.write_files()
}
