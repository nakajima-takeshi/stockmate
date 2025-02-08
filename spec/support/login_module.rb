module LoginModule
    def line_login
        mock_auth_hash
        visit root_path
        click_link 'LINE登録で始める'
    end
end
