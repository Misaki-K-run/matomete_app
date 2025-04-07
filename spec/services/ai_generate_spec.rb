require 'rails_helper'

RSpec.describe AiGenerateService, type: :service do
  describe '#call' do
    before do
      stub_request(:post, "https://api.openai.com/v1/chat/completions").
        to_return(
          status: 200,
          body: {
            choices: [
              {
                message: {
                  content: {
                    menu: {
                      "day 1" => [ "焼き魚", "ほうれん草のおひたし", "味噌汁" ]
                    },
                    shopping_list: [
                      { item: "鮭", quantity: "2切れ", estimated_price: 500 },
                      { item: "ほうれん草", quantity: "1束", estimated_price: 150 }
                    ],
                    total_price: 650
                  }.to_json
                }
              }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'returns parsed menu, shopping list, and total price' do
      service = AiGenerateService.new(
        budget_request: 5000,
        people_request: 2,
        allergies: "卵",
        favorite_ingredients: "鮭、ほうれん草",
        special_request: "和食中心"
      )

      result = service.call

      expect(result[:menu_response]).to include("day 1" => array_including("焼き魚"))
      expect(result[:shopping_list_response]).to include(
        include("item" => "鮭", "estimated_price" => 500)
      )
      expect(result[:sum_response]).to eq(650)
    end
  end
end
