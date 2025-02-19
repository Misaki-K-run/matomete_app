class AiGenerateService
    def initialize(budget_request:, people_request:, allergies:, favorite_ingredients:, special_request:)
      @budget_request = budget_request
      @people_request = people_request
      @allergies = allergies.presence || "なし"
      @favorite_ingredients = favorite_ingredients.presence || "なし"
      @special_request = special_request.presence || "特に指定なし"
    end

    def call
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          temperature: 0.7,
          messages: [
            { role: "system", content: "あなたは栄養バランスの良い献立を提案する専門家です。" },
            { role: "user", content: user_prompt }
          ]
        }
      )

      parsed_response = JSON.parse(response.dig("choices", 0, "message", "content")) rescue {}

      {
        menu_response: parsed_response["menu"] || {},
        shopping_list_response: parsed_response["shopping_list"] || {},
        sum_response: parsed_response["total_price"] || 0
      }
    end

    private

    def user_prompt
      <<~PROMPT
      一週間の夜ご飯の献立を栄養バランスを考えて作成して下さい。その献立に使う食材の買い物リストを生成してください。
      予算: #{@budget_request}円
      人数: #{@people_request}人
      アレルギー: #{@allergies}
      好きな食材: #{@favorite_ingredients}

      アレルギーの食材は使用しないでください。好きな食材を含めて使用して作成して下さい。
      もし、#{@special_request}というリクエストがあれば、それも考慮して献立を作成してください。
      食材の価格は一般的なスーパーマーケットの平均的な価格を想定してください。

      以下は返答のフォーマット例です。結果は以下のJSONフォーマットで返してください:
      {
      "menu": {
        "day 1": ["主菜", "副菜", "汁物"],
        },
      "shopping_list": [
        {"item": "鶏もも肉", "quantity": "300g", "estimated_price": 300},
        {"item": "大根", "quantity": "1/2本", "estimated_price": 100},
        {"item": "豚バラ肉", "quantity": "200g", "estimated_price": 350}
      ],
      "total_price": 4000
      }
      PROMPT
    end
end
