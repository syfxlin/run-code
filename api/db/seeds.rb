languages = [
  {
    name: "C",
    source_file: "main.c",
    compile_cmd: "/usr/bin/gcc %s main.c",
    run_cmd: "./a.out"
  },
  {
    name: "C++",
    source_file: "main.cpp",
    compile_cmd: "/usr/bin/g++ %s main.cpp",
    run_cmd: "./a.out"
  },
  {
    name: "Bash",
    source_file: "script.sh",
    run_cmd: "/usr/bin/bash script.sh"
  },
  {
    name: "C#",
    source_file: "Main.cs",
    compile_cmd: "/usr/bin/mcs %s Main.cs",
    run_cmd: "/usr/bin/mono Main.exe"
  },
  {
    name: "Go",
    source_file: "main.go",
    compile_cmd: "/usr/bin/go build %s main.go",
    run_cmd: "./main"
  },
  {
    name: "Java",
    source_file: "Main.java",
    compile_cmd: "/usr/bin/javac %s Main.java",
    run_cmd: "/usr/bin/java Main"
  },
  {
    name: "Node",
    source_file: "main.js",
    run_cmd: "/usr/bin/node main.js"
  },
  {
    name: "PHP",
    source_file: "main.php",
    run_cmd: "/usr/bin/php main.php"
  },
  {
    name: "Python3",
    source_file: "main.py",
    run_cmd: "/usr/bin/python3 main.py"
  },
  {
    name: "Python2",
    source_file: "main.py",
    run_cmd: "/usr/bin/python main.py"
  },
  {
    name: "Ruby",
    source_file: "main.rb",
    run_cmd: "/usr/bin/ruby main.rb"
  },
  {
    name: "Rust",
    source_file: "main.rs",
    compile_cmd: "/usr/bin/rustc %s main.rs",
    run_cmd: "./main"
  },
  {
    name: "Scala",
    source_file: "Main.java",
    compile_cmd: "/usr/bin/scalac %s Main.java",
    run_cmd: "/usr/bin/scala Main"
  },
  {
    name: "TypeScript",
    source_file: "main.ts",
    compile_cmd: "/usr/bin/tsc main.ts",
    run_cmd: "/usr/bin/node main.js"
  }
]


ActiveRecord::Base.transaction do
  Language.delete_all
  languages.each_with_index do |language, index|
    Language.create(
      id: index + 1,
      name: language[:name],
      compile_cmd: language[:compile_cmd],
      run_cmd: language[:run_cmd],
      source_file: language[:source_file]
    )
  end
end

