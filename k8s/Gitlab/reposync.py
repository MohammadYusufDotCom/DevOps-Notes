import os
import subprocess
import shutil
import requests
import sys

# Hardcoded tokens and server details
PRIVATE_TOKEN = "<ACCESS-TOKET-FOR-GITLAB>"
BITBUCKET_TOKEN = "<ACCESS-TOKEN-FOR-GITLAB>"

GITLAB_URL = "https://om-apigitlab.ooredoo.mv/"
GROUP_ID = "85"  
GROUP_NAME = "Superapp"  


if len(sys.argv) > 1:
    SERVICE_NAME = sys.argv[1]  # First argument: repository name
    SELECT_BRANCH = sys.argv[2]  # Second argument: branch name
    print(f"Repository Name: {SERVICE_NAME}")
    print(f"Branch Name: {SELECT_BRANCH}")
else:
    print("Usage: python script.py <repository_name> <branch_name>")
    sys.exit(1)
GITLAB_FULL_URL = f"https://mohd.yusuf:{PRIVATE_TOKEN}@om-apigitlab.ooredoo.mv/{GROUP_NAME}/{SERVICE_NAME}.git"

BITBUCKET_REPO_URL = f"https://omcicd:{BITBUCKET_TOKEN}@bitbucket.org/paytmteam/{SERVICE_NAME}.git"

def create_repo_if_not_exists(service_name):
    """Check if the repository exists in GitLab. If not, create it."""
    headers = {"Private-Token": PRIVATE_TOKEN}
    response = requests.get(
        f"{GITLAB_URL}/api/v4/groups/{GROUP_ID}/projects?search={service_name}",
        headers=headers,
        verify=False
    )
    if response.status_code == 200:
        projects = response.json()
        for project in projects:
            if project["name"] == service_name:
                print(f"Repository '{service_name}' already exists.")
                return GITLAB_FULL_URL

    print(f"Repository '{service_name}' does not exist. Creating it...")
    create_response = requests.post(
        f"{GITLAB_URL}/api/v4/projects",
        headers=headers,
        verify=False,
        json={"name": service_name, "namespace_id": GROUP_ID}
    )
    if create_response.status_code == 201:
        print(f"Repository '{service_name}' created successfully.")
        return create_response.json()["http_url_to_repo"]
    else:
        print(f"Failed to create repository: {create_response.status_code} {create_response.json()}")
        return None

def ensure_branch_exists(gitlab_repo_url, branch_name):
    """Ensure the branch exists in the GitLab repository."""
    headers = {"Private-Token": PRIVATE_TOKEN}
    repo_path = gitlab_repo_url.split('/')[-1].replace('.git', '')
    branch_check_url = f"{GITLAB_URL}/api/v4/projects/139/repository/branches/{SELECT_BRANCH}"
    response = requests.get(branch_check_url, headers=headers, verify=False)

    if response.status_code == 200:
        print(f"Branch '{branch_name}' already exists.")
        return True
    else:
        print(f"Branch '{branch_name}' does not exist. Creating it...")
        # Create the branch
        # create_branch_url = f"{GITLAB_URL}/api/v4/projects/{GROUP_ID}%2F{repo_path}/repository/branches"
        create_branch_url = f"{GITLAB_URL}/api/v4/projects/139/repository/branches"
        default_branch = "main"
        create_response = requests.post(
            create_branch_url,
            headers=headers,
            verify=False,
            json={"branch": branch_name, "ref": default_branch}
        )
        if create_response.status_code == 201:
            print(f"Branch '{branch_name}' created successfully.")
            return True
        else:
            print(f"Failed to create branch: {create_response.status_code} {create_response.json()}")
            return False

def clone_and_push_repo(bitbucket_repo_url, branch_name, gitlab_repo_url):
    """Clone the repository from Bitbucket and push it to GitLab."""
    if os.path.exists(SERVICE_NAME):
        print(f"Directory '{SERVICE_NAME}' already exists. Deleting it...")
        shutil.rmtree(SERVICE_NAME)

    print(f"Cloning the Bitbucket repository: {bitbucket_repo_url}")
    clone_command = [
        "git", "clone",
        "-b", branch_name,
        bitbucket_repo_url
        # "--single-branch"
    ]
    subprocess.run(clone_command, check=True)

    os.chdir(SERVICE_NAME)
    print(f"Current working directory is: {os.listdir()}")
    authenticated_gitlab_repo_url = f"https://Mohd.yusuf:{PRIVATE_TOKEN}@om-apigitlab.ooredoo.mv/{GROUP_NAME}/{SERVICE_NAME}.git"

    print(f"Adding GitLab remote: {authenticated_gitlab_repo_url}")
    subprocess.run(["git", "remote", "add", "gitlab", authenticated_gitlab_repo_url], check=True)

    print("Pushing to GitLab...")
    subprocess.run(["git", "push", "--all", "gitlab","--force"], check=True)

    print(f"Switching to branch: {branch_name}")
    subprocess.run(["git", "checkout", branch_name], check=True)

    subprocess.run(["git", "push", "-u", "gitlab", branch_name], check=True)

    os.chdir("..")

# Main execution
if __name__ == "__main__":
    gitlab_repo_url = create_repo_if_not_exists(SERVICE_NAME)
    if gitlab_repo_url and ensure_branch_exists(gitlab_repo_url, SELECT_BRANCH):
        clone_and_push_repo(BITBUCKET_REPO_URL, SELECT_BRANCH, gitlab_repo_url)
    else:
        print("Failed to set up the repository or branch. Exiting.")
        sys.exit(1)
