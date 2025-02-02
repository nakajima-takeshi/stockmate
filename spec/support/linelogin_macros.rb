module LineloginMacros
    def mock_auth_hash
        OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
            provider: 'line',
            uid: '12345',
            info: {
                email: 'test@example.com',
                name: 'Test User'
            }
        })
    end
end
