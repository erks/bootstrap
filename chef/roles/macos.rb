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
            'alt-tab',
            'intellij-idea-ce',
            'visual-studio-code',
        ]
    }
)
