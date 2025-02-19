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
          messages: [
            { role: "system", content: "あなたは優秀な料理プランナーです。" },
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

      結果は以下のJSONフォーマットで返してください:
      {
      "menu": {
        "day 1": ["納豆", "ご飯", "焼き魚"],
        "day 2": ["トマトとナスのパスタ", "サラダ"],
        },
        "shopping_list": {
          "meat_fish": [{"item": "鶏肉", "quantity": "500g"}, {"item": "さば", "quantity": "２匹"}],
          "vegetables": [{"item": "玉ねぎ", "quantity": "2個"}, {"item": "にんじん", "quantity": "3本"}]
        },
        "total_price": 4000
      }
      PROMPT
    end

end
