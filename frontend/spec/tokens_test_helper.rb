# -*- coding: utf-8 -*-
module TokensTestHelper
  ONETIME_TOKEN_HASH = {
    "Ilość tokenów" => 20,
    "Data ważności" => "2100-01-01"
  }

  REUSABLE_TOKEN_HASH = {
    "Data ważności" => "2100-01-01",
    "Liczba użyć" => 20
  }

  def onetime_hash
    ONETIME_TOKEN_HASH
  end

  def reusable_hash
    REUSABLE_TOKEN_HASH.merge("Nazwa" => Time.now.to_f.to_s)
  end

  def onetime_token(values = {})
    generate_test_token(onetime_hash.merge(values))
  end

  def reusable_token(values = {})
    generate_test_token(reusable_hash.merge(values))
  end

  def generate_test_token(token_hash)
    click_link 'Generuj tokeny'
    token_hash.each { |field, value| fill_in field, :with => value }
    click_button 'Generuj tokeny'
  end
end

include TokensTestHelper
