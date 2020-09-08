require 'rails_helper'

RSpec.describe "/characters", type: :request do
  let(:user) { create(:user) }
  let(:parent_project) { create(:project, character_directory: directory, is_published: project_published, author: author) }
  let(:directory) { create(:character_directory, is_published: directory_published) }
  let(:character) { create(:character, is_published: character_published, directory: directory) }
  let(:project_published) { is_published }
  let(:directory_published) { is_published }
  let(:character_published) { is_published }
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
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end

          example 'characterが含まれること' do
            character = create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json

            data = JSON.parse(response.body)
            expect(data.length).to eq 1
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json
            expect(response).to be_successful
          end

          example 'characterが含まれないこと' do
            character = create(:character, is_published: character_published, directory: directory)

            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_characters_url(parent_project), headers: auth_params, as: :json

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
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '正しく表示されること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)
            get project_character_directory_character_url(parent_project, character), headers: auth_params, as: :json
            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "POST /create" do
      describe '自分のプロジェクト' do
        let(:author) { user }

        context '全てが公開中の場合' do
          let(:is_published) { true }
          context "with valid parameters" do
            it "creates a new Character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              expect {
                post project_character_directory_characters_url(parent_project),
                  params: { character: attributes_for(:character) },
                  headers: auth_params,
                  as: :json
              }.to change(Character, :count).by(1)
            end

            it "renders a JSON response with the new character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              post project_character_directory_characters_url(parent_project),
                params: { character: attributes_for(:character) },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:created)
              expect(response.content_type).to match(a_string_including("application/json"))
            end
          end

          context "with invalid parameters" do
            it "does not create a new Character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              expect {
                post project_character_directory_characters_url(parent_project),
                  params: { character: attributes_for(:character, term_id: '@test') },
                  headers: auth_params,
                  as: :json
              }.to change(Character, :count).by(0)
            end

            it "renders a JSON response with errors for the new character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              post project_character_directory_characters_url(parent_project),
                params: { character: attributes_for(:character, term_id: '@test') },
                headers: auth_params,
                as: :json
              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.content_type).to include("application/json")
            end
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          context "with valid parameters" do
            it "creates a new Character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              expect {
                post project_character_directory_characters_url(parent_project),
                  params: { character: attributes_for(:character) },
                  headers: auth_params,
                  as: :json
              }.to change(Character, :count).by(1)
            end

            it "renders a JSON response with the new character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              post project_character_directory_characters_url(parent_project),
                params: { character: attributes_for(:character) },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:created)
              expect(response.content_type).to match(a_string_including("application/json"))
            end
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          context "with valid parameters" do
            it "creates a new Character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              expect {
                post project_character_directory_characters_url(parent_project),
                  params: { character: attributes_for(:character) },
                  headers: auth_params,
                  as: :json
              }.to change(Character, :count).by(1)
            end

            it "renders a JSON response with the new character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              post project_character_directory_characters_url(parent_project),
                params: { character: attributes_for(:character) },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:created)
              expect(response.content_type).to match(a_string_including("application/json"))
            end
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "PATCH /update" do
      let(:new_attributes) {
        { name: 'new_name' }
      }

      describe '自分のプロジェクト' do
        let(:author) { user }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          context "with valid parameters" do
            let(:new_attributes) {
              { name: 'new_name' }
            }

            it "updates the requested character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              character.reload
              expect(character.name).to eq 'new_name'
            end

            it "renders a JSON response with the character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:ok)
              expect(response.content_type).to include("application/json")
            end
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          context "with valid parameters" do
            let(:new_attributes) {
              { name: 'new_name' }
            }

            it "updates the requested character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              character.reload
              expect(character.name).to eq 'new_name'
            end

            it "renders a JSON response with the character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:ok)
              expect(response.content_type).to include("application/json")
            end
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          context "with valid parameters" do
            let(:new_attributes) {
              { name: 'new_name' }
            }

            it "updates the requested character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              character.reload
              expect(character.name).to eq 'new_name'
            end

            it "renders a JSON response with the character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:ok)
              expect(response.content_type).to include("application/json")
            end
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          context "with valid parameters" do
            let(:new_attributes) {
              { name: 'new_name' }
            }

            it "updates the requested character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              character.reload
              expect(character.name).to eq 'new_name'
            end

            it "renders a JSON response with the character" do
              auth_params = get_auth_params_from_login_response_headers(response)

              patch project_character_directory_character_url(parent_project, character),
                params: { character: new_attributes },
                headers: auth_params,
                as: :json

              expect(response).to have_http_status(:ok)
              expect(response.content_type).to include("application/json")
            end
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          example "権限エラーになること" do
            auth_params = get_auth_params_from_login_response_headers(response)

            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example "権限エラーになること" do
            auth_params = get_auth_params_from_login_response_headers(response)

            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example "権限エラーになること" do
            auth_params = get_auth_params_from_login_response_headers(response)

            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example "権限エラーになること" do
            auth_params = get_auth_params_from_login_response_headers(response)

            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "DELETE /destroy" do
      describe '自分のプロジェクト' do
        let(:author) { user }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          it "destroys the requested character" do
            auth_params = get_auth_params_from_login_response_headers(response)

            character

            expect {
              delete project_character_directory_character_url(parent_project, character),
              headers: auth_params
            }.to change(Character, :count).by(-1)
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { true }

          it "destroys the requested character" do
            auth_params = get_auth_params_from_login_response_headers(response)

            character

            expect {
              delete project_character_directory_character_url(parent_project, character),
              headers: auth_params
            }.to change(Character, :count).by(-1)
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { true }

          it "destroys the requested character" do
            auth_params = get_auth_params_from_login_response_headers(response)

            character

            expect {
              delete project_character_directory_character_url(parent_project, character),
              headers: auth_params
            }.to change(Character, :count).by(-1)
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { true }

          it "destroys the requested character" do
            auth_params = get_auth_params_from_login_response_headers(response)

            character

            expect {
              delete project_character_directory_character_url(parent_project, character),
              headers: auth_params
            }.to change(Character, :count).by(-1)
          end
        end
      end

      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            delete project_character_directory_character_url(parent_project, character),
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { true }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            delete project_character_directory_character_url(parent_project, character),
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { true }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            delete project_character_directory_character_url(parent_project, character),
              headers: auth_params,
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { true }

          example '権限エラーになること' do
            auth_params = get_auth_params_from_login_response_headers(response)

            delete project_character_directory_character_url(parent_project, character),
              headers: auth_params,
              as: :json

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
            create(:character, is_published: character_published, directory: directory)

            get project_character_directory_characters_url(parent_project), as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            create(:character, is_published: character_published, directory: directory)

            get project_character_directory_characters_url(parent_project), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            create(:character, is_published: character_published, directory: directory)

            get project_character_directory_characters_url(parent_project), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '正しく表示されること' do
            create(:character, is_published: character_published, directory: directory)

            get project_character_directory_characters_url(parent_project), as: :json
            expect(response).to be_successful
          end

          example 'characterが含まれないこと' do
            character = create(:character, is_published: character_published, directory: directory)

            get project_character_directory_characters_url(parent_project), as: :json

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
            get project_character_directory_character_url(parent_project, character), as: :json
            expect(response).to be_successful
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            get project_character_directory_character_url(parent_project, character), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            get project_character_directory_character_url(parent_project, character), as: :json
            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example '権限エラーになること' do
            get project_character_directory_character_url(parent_project, character), as: :json
            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "POST /create" do
      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          example '権限エラーになること' do
            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example '権限エラーになること' do
            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example '権限エラーになること' do
            post project_character_directory_characters_url(parent_project),
              params: { character: attributes_for(:character) },
              as: :json

            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "PATCH /update" do
      let(:new_attributes) {
        { name: 'new_name' }
      }
      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          example "権限エラーになること" do
            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { false }

          example "権限エラーになること" do
            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { false }

          example "権限エラーになること" do
            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { false }

          example "権限エラーになること" do
            patch project_character_directory_character_url(parent_project, character),
              params: { character: new_attributes },
              as: :json

            expect(response.status).to eq 403
          end
        end
      end
    end

    describe "DELETE /destroy" do
      describe '他人のプロジェクト' do
        let(:author) { create(:user, name: 'other_user') }

        context '全てが公開中の場合' do
          let(:is_published) { true }

          example '権限エラーになること' do
            delete project_character_directory_character_url(parent_project, character),
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'projectが非公開の場合' do
          let(:project_published) { true }

          example '権限エラーになること' do
            delete project_character_directory_character_url(parent_project, character),
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'directoryが非公開の場合' do
          let(:directory_published) { true }

          example '権限エラーになること' do
            delete project_character_directory_character_url(parent_project, character),
              as: :json

            expect(response.status).to eq 403
          end
        end

        context 'characterが非公開の場合' do
          let(:character_published) { true }

          example '権限エラーになること' do
            delete project_character_directory_character_url(parent_project, character),
              as: :json

            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end
