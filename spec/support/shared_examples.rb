shared_examples "an endpoint that requires authentication" do |method, path, headers: {}|
  context 'when unauthenticated' do
    it 'returns unauthorized status code' do
      url = send(path, headers)
      send(method, url)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthenticated message' do
      url = send(path, headers)
      send(method, url)
      expect(response.body).to include(I18n.t('devise.failure.unauthenticated'))
    end
  end
end
