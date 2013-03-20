random_repo_path = File.expand_path(node.random_repo_path)

git random_repo_path do
    repository node.random_repo_url
    revision "master"
end

