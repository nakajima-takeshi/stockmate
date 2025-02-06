module OmniauthMacros
    def mock_auth_hash
        OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
            provider: 'line',
            uid: '12345',
            info: {
                email: 'test@example.com',
                name: 'Test User'
            },
            credentials: { 
                token: 'mock_token',
                refresh_token: 'mock_refresh_token',
                expires_at: Time.now + 1.week
            }
        })
    end
end
