require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "projects/:id/dictionary/words", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Word. As you add validations to Word, be sure to
  # adjust the attributes here as well.
  # let(:valid_model) {
  #   FactoryBot.create(:word)
  # }

  # let(:invalid_model) {
  #   FactoryBot.create(:word, name: 'a' * 141)
  # }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # WordsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  let(:user) { create(:user) }
  let(:parent_project) { create(:project, dictionary: dictionary, is_published: project_published, author: author) }
  let(:dictionary) { create(:dictionary, is_published: dictionary_published) }
  let(:word) { create(:word, is_published: word_published, dictionary: dictionary) }
  let(:project_published) { is_published }
  let(:dictionary_published) { is_published }
  let(:word_published) { is_published }
  let(:is_published) { true }

  describe 'login時' do
    before do
      login user
    end

    describe "GET /index" do
      describe '自分のプロジェクト' do
        let(:author) { user }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end

          example 'wordが含まれること' do
            word = create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json

            data = JSON.parse(response.body)
            expect(data.length).to eq 1
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '権限エラーになること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end

          example 'wordが含まれないこと' do
            word = create(:word, is_published: word_published, dictionary: dictionary)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_words_url(parent_project), headers: auth_params, as: :json

            data = JSON.parse(response.body)
            expect(data.length).to eq 0
          end
        end
      end
    end

    describe "GET /show" do
      describe '自分のプロジェクト' do
        let(:author) { user }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_dictionary_word_url(parent_project, word), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end
      end
    end
  end

  describe '非login時' do
    describe "GET /index" do
      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            get project_dictionary_words_url(parent_project), as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            get project_dictionary_words_url(parent_project), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '権限エラーになること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            get project_dictionary_words_url(parent_project), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '正しく表示されること' do
            create(:word, is_published: word_published, dictionary: dictionary)

            get project_dictionary_words_url(parent_project), as: :json
            expect(response).to be_successful
          end

          example 'wordが含まれないこと' do
            word = create(:word, is_published: word_published, dictionary: dictionary)

            get project_dictionary_words_url(parent_project), as: :json

            data = JSON.parse(response.body)
            expect(data.length).to eq 0
          end
        end
      end
    end

    describe "GET /show" do
      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            get project_dictionary_word_url(parent_project, word), as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            get project_dictionary_word_url(parent_project, word), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'dictionaryが非公開の場合' do
          let(:dictionary_published) { false }

          example '権限エラーになること' do
            get project_dictionary_word_url(parent_project, word), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'wordが非公開の場合' do
          let(:word_published) { false }

          example '権限エラーになること' do
            get project_dictionary_word_url(parent_project, word), as: :json
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end