module LoginModule
    def line_login
        mock_auth_hash
        visit root_path
        click_button 'LINE登録で始める'
    end
end
