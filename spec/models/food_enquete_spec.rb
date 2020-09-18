require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:やきそば food_id: 2,
                            満足度:良い score: 3,
                            希望するプレゼント:ビール飲み放題 present_id: 1)' do

        # [Point.3-3-1]テストデータを作成します。
        enquete = FoodEnquete.new(
          name: '田中 太郎',
          mail: 'taro.tanaka@example.com',
          age: 25,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )
        # [Point.3-3-2]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete).to be_valid
        enquete.save

        answered_enquete = FoodEnquete.first
        # [Point.3-3-5][Point.3-3-1]で作成したデータを同一か検証します。
        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)
        # ==========ここまで追加する==========
      end
    end
  end

  describe '入力項目の有無' do
    context '必須入力であること' do
      it 'お名前が必須であること' do
        new_enquete = FoodEnquete.new
        # バリデーションエラーが発生し、保存が失敗することを確認
        expect(new_enquete).not_to be_valid
        # 必須入力のメッセージが含まれていることを検証
        expect(new_enquete.save).to be_falsy
      end
    end

    context '任意入力であること' do
      it "ご意見・ご要望が任意であること" do
        new_enquete = FoodEnquete.new
        expect(new_enquete).not_to be_valid
        # エラーメッセージが含まれていないこと
        expect(new_enquete.errors).not_to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'アンケート回答時の条件' do
    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do
        enquete_sato = FoodEnquete.new(
          name: '佐藤仁美',
          mail: 'hitomi.sato@example.com',
          age: 19,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1 #ビール飲み放題
        )

        expect(enquete_sato).not_to be_valid
        # 成人のみ選択できる旨のメッセージが含まれることを検証します。
        expect(enquete_sato.errors[:present_id]).to include("は成人の方のみ選択できます")
      end

      it '成人はビール飲み放題を選択できること' do
        enquete_sato = FoodEnquete.new(
          name: '佐藤仁美',
          mail: 'hitomi.sato@example.com',
          age: 20,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1 #ビール飲み放題
        )
        expect(enquete_sato).to be_valid
      end
    end
  end

  describe '#adult?' do
    it '20歳以上は成人であること' do
      FoodEnquete = FoodEnquete.new
      expect(FoodEnquete.send(:adult?, 19)).to be_falsy
    end

    it "20歳以上は成人であること" do
      expect(FoodEnquete.send(:adult?, 20)).to be_truthy
    end
  end
end
