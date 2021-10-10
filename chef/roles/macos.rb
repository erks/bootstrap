name "macos"
run_list "recipe[bootstrap]"
default_attributes(
    :bootstrap => {
        :name => 'Touch Ungboriboonpisal',
        :email => 'touch@ungboriboonpisal.com'
    },
    :homebrew => {
        :taps => [],
        :formulas => [
            'git',
            'jq',
            'tree'
        ],
        :casks => []
    }
)
