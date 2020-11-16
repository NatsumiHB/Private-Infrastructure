# Things to keep in mind
To register the GitLab runner, run `docker run --rm -it -v /path/to/runner/config:/etc/gitlab-runner --network="gitlab_gitlab-net" gitlab/gitlab-runner register` and specify `http://gitlab_app_1:5556` as the GitLab URL.
