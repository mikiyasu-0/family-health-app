class BodyMemoGenerator
  FALLBACK_CONTENT = "今日も記録できていて素晴らしいです。無理のない範囲で、姿勢や足元に気をつけながら続けていきましょう。".freeze
  NO_RECORD_CONTENT = "今日の運動記録をすると、からだメモが表示されます。".freeze

  def initialize(user:, date: Time.zone.today)
    @user = user
    @date = date
  end

  def call
    existing_memo = BodyMemo.find_by(user: user, memo_date: date)
    return existing_memo if existing_memo.present?

    return no_record_body_memo if today_exercise_records.blank?

    content = generate_content

    if content.blank?
      create_body_memo!(content: FALLBACK_CONTENT, fallback: true)
    else
      create_body_memo!(content: content, fallback: false)
    end
  rescue StandardError => e
    Rails.logger.warn("[BodyMemoGenerator] #{e.class}: #{e.message}")

    create_body_memo!(
      content: FALLBACK_CONTENT,
      fallback: true
    )
  end

  private

  attr_reader :user, :date

  def generate_content
    response = client.responses.create(
      model: ENV.fetch("OPENAI_MODEL", "gpt-5.4-mini"),
      input: [
        { role: :system, content: system_prompt },
        { role: :user, content: user_prompt }
      ],
      request_options: {
        timeout: 10
      }
    )

    response.output
            .flat_map(&:content)
            .filter_map { |content| content[:text] || content["text"] }
            .join
            .strip
  end

  def client
    @client ||= OpenAI::Client.new(
      api_key: ENV.fetch("OPENAI_API_KEY")
    )
  end

  def today_exercise_records
    @today_exercise_records ||= user.exercise_records
                                    .where(created_at: date.all_day)
                                    .order(:created_at)
  end

  def user_prompt
    exercise_names = today_exercise_records.map do |record|
      exercise_type_name(record.exercise_type)
    end

    memo_texts = today_exercise_records.map(&:memo).filter_map(&:presence)

    <<~PROMPT
      今日の運動記録は以下です。

      運動内容:
      #{exercise_names.join("、")}

      ユーザーのメモ:
      #{memo_texts.presence&.join(" / ") || "なし"}

      上記をもとに、今日のからだメモを作成してください。
    PROMPT
  end

  def system_prompt
    <<~PROMPT
      あなたは家族で運動習慣を続けるアプリ「ファミリーステップ」の応援コメント作成者です。

      以下の条件を必ず守ってください。

      - 日本語で書く
      - 80文字以内
      - やさしく前向きな表現にする
      - 医療的な効果を断定しない
      - 痛み、病気、治療、診断に関する助言をしない
      - 「治る」「改善する」「予防できる」「効果がある」と断定しない
      - 運動時の注意点を1つ入れる
      - 運動を続けることで期待できる一般的なメリットをやわらかく伝える
      - 不安をあおらない
      - 専門的すぎる表現は避ける
    PROMPT
  end

  def exercise_type_name(exercise_type)
    {
      "walk" => "散歩",
      "chair_squat" => "椅子スクワット",
      "heel_raise" => "踵上げ",
      "rest" => "休息"
    }.fetch(exercise_type, exercise_type)
  end

  def create_body_memo!(content:, fallback:)
    BodyMemo.create!(
      user: user,
      memo_date: date,
      content: content.presence || FALLBACK_CONTENT,
      fallback: fallback
    )
  rescue ActiveRecord::RecordNotUnique
    BodyMemo.find_by!(user: user, memo_date: date)
  end

  def no_record_body_memo
    BodyMemo.new(
      user: user,
      memo_date: date,
      content: NO_RECORD_CONTENT,
      fallback: true
    )
  end
end
