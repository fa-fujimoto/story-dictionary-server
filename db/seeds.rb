# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

myAccount = User.create!(
  nickname: 'こよみん',
  name: 'mirai_koyomi',
  email: 'crossclose00@gmail.com',
  password: 'Password@3333',
  password_confirmation: 'Password@3333'
)

published_word = ['公開', '非公開']
is_published = [:published, :protect]

post_type = [:word, :character, :group]
kind = [:string, :integer, :text, :markdown]

30.times do |n|
  AttributeItem.create(
    name: "#{published_word[n % 2]}デフォルト項目#{n}",
    post_type: post_type[n % 3],
    kind: kind[n % 4],
    required: false,
    default_item: true
  )
end

post_type_word = ['用語', 'キャラクター', 'グループ']

15.times do |n|
  project = myAccount.projects.create(
    term_id: "term_id#{n}",
    name: "自分の#{published_word[n % 2]}プロジェクト#{n}",
    kana: "じぶんのぷろじぇくと#{n}",
    description: "#{published_word[n % 2]}プロジェクトです。",
    is_published: is_published[n % 2],
    commentable_status: :free,
    comment_viewable: :open,
    comment_publish: :soon
  )

  AttributeItem.where(default_item: true).map do |item|
    project.attribute_items << item
  end

  attribute_values = project.attribute_items.map do |item|
    item_attr = {
      attribute_item_id: item.id,
    }

    case item.kind
    when 'string'
      item_attr[:string] = 'default string'
    when 'integer'
      item_attr[:integer] = 255
    when 'text'
      item_attr[:text] = 'default text'
    when 'markdown'
      item_attr[:markdown] = '#default text'
    end

    item_attr
  end

  kind = [:word, :character, :group]

  15.times do |n|
    category = project.categories.create(
      term_id: "term_id#{n}",
      name: "自分のCategory#{n}",
      synopsis: "category synopsis",
      body: "category synopsis" * 40,
      kind: kind[n % 3]
    )

    10.times do |n|
      if category.kind_word?
        category.posts.create!(
          term_id: "#{category.term_id}term_id#{n}",
          name: "#{category.name}自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "じぶんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          author: project.author,
          project: project,
          attribute_values_attributes: attribute_values,
          word_attributes: {}
        )
      elsif category.kind_character?
        category.posts.create(
          term_id: "#{category.term_id}term_id#{n}",
          name: "#{category.name}自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "じぶんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          project: project,
          author: project.author,
          attribute_values_attributes: attribute_values,
          character_attributes: {}
        )
      elsif category.kind_group?
        category.posts.create(
          term_id: "#{category.term_id}term_id#{n}",
          name: "#{category.name}自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "じぶんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          author: project.author,
          project: project,
          attribute_values_attributes: attribute_values,
          group_attributes: {}
        )
      end
    end
  end

  30.times do |n|
    case n % 3
    when 0
      project.posts.create!(
        term_id: "term_id#{n}",
        name: "自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
        kana: "じぶんのようご#{n}",
        synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
        status: is_published[n % 2],
        author: project.author,
        attribute_values_attributes: attribute_values,
        word_attributes: {}
      )
    when 1
      project.posts.create(
        term_id: "term_id#{n}",
        name: "自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
        kana: "じぶんのようご#{n}",
        synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
        status: is_published[n % 2],
        author: project.author,
        attribute_values_attributes: attribute_values,
        character_attributes: {}
      )
    when 2
      project.posts.create(
        term_id: "term_id#{n}",
        name: "自分の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
        kana: "じぶんのようご#{n}",
        synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
        status: is_published[n % 2],
        author: project.author,
        attribute_values_attributes: attribute_values,
        group_attributes: {}
      )
    end
  end
end

10.times do |n|
  user = User.create(
    nickname: "username#{n}",
    name: "user_id#{n}",
    email: "test#{n}@test.com",
    password: "Password@#{n}",
    password_confirmation: "Password@#{n}"
  )

  p user

  10.times do |n|
    project = user.projects.create(
      term_id: "term_id#{n}",
      name: "他人の#{published_word[n % 2]}プロジェクト#{n}",
      kana: "たにんのぷろじぇくと#{n}",
      description: "#{published_word[n % 2]}プロジェクトです。",
      is_published: is_published[n % 2],
      commentable_status: :free,
      comment_viewable: :open,
      comment_publish: :soon
    )

    AttributeItem.where(default_item: true).map do |item|
      project.attribute_items << item
    end

    attribute_values = project.attribute_items.map do |item|
      item_attr = {
        attribute_item_id: item.id,
      }

      case item.kind
      when 'string'
        item_attr[:string] = 'default string'
      when 'integer'
        item_attr[:integer] = 255
      when 'text'
        item_attr[:text] = 'default text'
      when 'markdown'
        item_attr[:markdown] = '#default text'
      end

      item_attr
    end

    kind = [:word, :character, :group]

    9.times do |n|
      category = project.categories.create(
        term_id: "term_id#{n}",
        name: "他人のCategory#{n}",
        synopsis: "category synopsis",
        body: "category synopsis" * 40,
        kind: kind[n % 3]
      )

      3.times do |n|
        p category
        p category.kind_word?
        if category.kind_word?
          category.posts.create!(
            term_id: "#{category.term_id}term_id#{n}",
            name: "#{category.name}他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
            kana: "じぶんのようご#{n}",
            synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
            status: is_published[n % 2],
            author: project.author,
            project: project,
            attribute_values_attributes: attribute_values,
            word_attributes: {}
          )
        elsif category.kind_character?
          category.posts.create(
            term_id: "#{category.term_id}term_id#{n}",
            name: "#{category.name}他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
            kana: "じぶんのようご#{n}",
            synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
            status: is_published[n % 2],
            author: project.author,
            project: project,
            attribute_values_attributes: attribute_values,
            character_attributes: {}
          )
        elsif category.kind_group?
          category.posts.create(
            term_id: "#{category.term_id}term_id#{n}",
            name: "#{category.name}他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
            kana: "じぶんのようご#{n}",
            synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
            status: is_published[n % 2],
            author: project.author,
            project: project,
            attribute_values_attributes: attribute_values,
            group_attributes: {}
          )
        end
      end
    end

    10.times do |n|
      case n % 3
      when 0
        project.posts.create(
          term_id: "term_id#{n}",
          name: "他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "たにんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          author: project.author,
          word_attributes: {}
        )
      when 1
        project.posts.create(
          term_id: "term_id#{n}",
          name: "他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "じぶんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          author: project.author,
          character_attributes: {}
        )
      when 2
        project.posts.create(
          term_id: "term_id#{n}",
          name: "他人の#{published_word[n % 2]}#{post_type_word[n % 3]}#{n}",
          kana: "じぶんのようご#{n}",
          synopsis: "#{published_word[n % 2]}#{post_type_word[n % 3]}です。",
          status: is_published[n % 2],
          author: project.author,
          group_attributes: {}
        )
      end
    end
  end
end

permission = [:view, :edit, :admin]
approval = [:approved, :unapproved]

User.count.times do |n|
  if (n % 2 == 1)
    user = User.find(n)
    projects = Project.where.not(user_id: user.id).shuffle.take(30)

    projects.count.times do |i|
      project = projects[i]

      project_follower = ProjectFollower.create(user_id: user.id, project_id: project.id, permission: permission[i % 3], approval: approval[i % 2])
      p project_follower
    end
  end
end