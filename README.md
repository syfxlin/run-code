# Run Code

> run code for [XK-Editor](https://github.com/syfxlin/xkeditor)

本仓库是基于 [Judge0 API](https://github.com/judge0/api) 修改而来，重新编写了Dockerfile，添加一些编程语言，用以支持XK-Editor运行除JavaScript外的语言。

## 支持的语言

| ID | 语言       |
|----|------------|
| 1  | C          |
| 2  | C++        |
| 3  | Bash       |
| 4  | C#         |
| 5  | Go         |
| 6  | Java       |
| 7  | Node       |
| 8  | PHP        |
| 9  | Python3    |
| 10 | Python2    |
| 11 | Ruby       |
| 12 | Rust       |
| 13 | Scala      |
| 14 | Typescript |

## 安装

克隆此仓库，进入run文件夹，利用docker-compose启动容器

```bash
git clone https://github.com/syfxlin/run-code.git
cd run-code/run
docker-compose up -d
```

## FAQ

**我想要运行的语言不在该列表怎么办？**

修改`base`文件夹下的`Dockerfile`文件，添加您需要的语言的运行环境和编译环境，然后修改`api/db`文件夹下的`seeds.rb`文件，参考其他语言的例子编写编译命令和运行命令。

然后build`base`和`api`两个docker镜像，**注意**：您可能需要修改tag名称。

最后按安装的方式启动容器。

## Thinks

- [judge0/api](https://github.com/judge0/api)
- [judge0/api-base](https://github.com/judge0/api-base)
