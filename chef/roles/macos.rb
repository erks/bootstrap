name "macos"
default_attributes(
    :bootstrap => {
        :name => 'Touch Ungboriboonpisal',
        :email => 'erks@users.noreply.github.com'
    },
    :homebrew => {
        :taps => [],
        :formulas => [
            'coreutils',
            'direnv',
            'git',
            'jq',
            'kube-ps1',
            'tree',
            'watch',
            'wget',
        ],
        :casks => [
            '1password',
            '1password-cli',
            'alt-tab',
            'intellij-idea',
            'visual-studio-code',
        ]
    }
)
