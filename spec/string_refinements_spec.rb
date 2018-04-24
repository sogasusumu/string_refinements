require 'string_refinements'

RSpec.describe StringRefinements do
  it "has a version number" do
    expect(StringRefinements::VERSION).not_to be nil
  end

  using StringRefinements
  describe 'normalize' do
    subject { target.normalize }
    let(:target) { 'Ｈｅｌｌｏ，　Ｗｏｒｌｄ！ ｢ﾊﾛｰﾜｰﾙﾄﾞ｣' }
    let(:expected) { 'Hello, World! 「ハローワールド」' }
    it { is_expected.to eq expected }
  end

  describe 'decode_to_jp' do
    subject { target.decode_to_jp 'UTF-8' }
    let(:target) { URI.encode "#{expected}" }
    let(:expected) { '日本語.jp' }
    it { is_expected.to eq expected }
  end

  describe 'refine' do
    subject { target.refine }
    let(:whitespaces) { ['　', ' ', "\t"] }
    let(:chars) { %w[a b c d] }
    let(:line_breaks) { %W[\r \n \r\n] }
    let(:expected) { chars.join("\n") }

    context 'bとcの間のみ改行がある場合' do
      let(:expected) { "a b\nc d" }
      let :target do
        target = String.new
        (1..10).to_a.sample.times { target << whitespaces.sample }
        chars.each do |char|
          target << char
          (1..10).to_a.sample.times { target << whitespaces.sample }
          (1..10).to_a.sample.times { target << line_breaks.sample } if char == 'b'
        end
        target
      end
      it { is_expected.to eq expected }
    end

    context '空白のみの場合' do
      let(:expected) { chars.join(' ') }
      let :target do
        target = String.new
        (1..10).to_a.sample.times { target << whitespaces.sample }
        chars.each do |char|
          target << char
          (1..10).to_a.sample.times { target << whitespaces.sample }
        end
        target
      end
      it { is_expected.to eq expected }
    end

    context '空白・改行がランダムに含まれている場合' do
      let :target do
        target = String.new
        (10..100).to_a.sample.times { target << (line_breaks + whitespaces).sample }
        chars.each do |char|
          target << char
          (10..100).to_a.sample.times { target << (line_breaks + whitespaces).sample }
        end
        target
      end
      it { is_expected.to eq expected }
    end
    context '先頭が空白で改行がランダム含まれている場合' do
      let :target do
        target = String.new
        (1..10).to_a.sample.times { target << whitespaces.sample }
        (1..10).to_a.sample.times { target << line_breaks.sample }
        chars.each do |char|
          target << char
          (1..10).to_a.sample.times { target << whitespaces.sample }
          (1..10).to_a.sample.times { target << line_breaks.sample }
        end
        target
      end
      it { is_expected.to eq expected }
    end
  end

  describe 'refine_whitespaces' do
    subject { target.refine_whitespaces }
    let(:whitespaces) { ['　', ' ', "\t"] }
    let(:chars) { %w[a b c d] }
    let(:expected) { chars.join(' ') }
    context '先頭末尾、文字ごとに１〜１０の空白が含まれている場合' do
      let :target do
        target = String.new
        (1..10).to_a.sample.times { target << whitespaces.sample }
        chars.each do |char|
          target << char
          (1..10).to_a.sample.times { target << whitespaces.sample }
        end
        target
      end
      it { is_expected.to eq expected }
    end
  end

  describe 'refine_line_breaks' do
    subject { target.refine_line_breaks }
    let(:line_breaks) { %W[\r \n \r\n] }
    let(:expected) { "a\nb\nc\nd" }
    context '各種改行コードが存在する場合' do
      let(:target) { "a\rb\r\nc\nd" }
      it { is_expected.to eq expected }
    end
    context '末尾に改行コードがある場合' do
      let(:target) { "a\rb\r\nc\nd#{line_breaks.sample}" }
      it { is_expected.to eq expected }
    end
    context '各種改行コードが複数回連続す場合' do
      let :target do
        target = String.new
        target << 'a'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'b'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'c'
        (1..10).to_a.sample.times { target << line_breaks.sample }
        target << 'd'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target
      end
      it { is_expected.to eq expected }
    end
    context '先頭にも改行コードがある場合' do
      let :target do
        target = String.new
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'a'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'b'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'c'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target << 'd'
        (2..10).to_a.sample.times { target << line_breaks.sample }
        target
      end
      it { is_expected.to eq expected }
    end
  end
end
