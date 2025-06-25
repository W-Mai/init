function init_yadm
    if not type -q yadm
        echo "[ERROR] yadm is not installed. Please install yadm first."
        return 1
    end

    if test (count $argv) -eq 0
        echo "[ERROR] No yadm repo URL provided."
        echo "Usage: init_yadm <git-repo-url>"
        return 1
    end

    set -l repo $argv[1]
    echo "[INFO] Cloning yadm repo: $repo"
    yadm clone "$repo"
end

function setup_dotfiles
    echo -n "Enter your yadm git repo URL: "
    read --prompt-str "Enter yadm repo URL: " repo_url < /dev/tty

    if test -z "$repo_url"
        echo "[WARN] No input provided, skipping yadm init."
        return
    end

    init_yadm "$repo_url"
end

