
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "string_refinements/version"

Gem::Specification.new do |spec|
  spec.name          = "string_refinements"
  spec.version       = StringRefinements::VERSION
  spec.authors       = ["sogasusumu"]
  spec.email         = ["soga@yocto-inc.com"]

  spec.summary       = %q{Rubyで日本語を扱う際に、よくある問題点を解決するためのGemです。}
  spec.description   = %q{次のメソッドが利用可能になります。連続した改行を一つの\nに統一する。連続したホワイトスペースを一つの半角スペースに統一する。全角英数を半角英数に統一する。両脇の無駄なホワイトスペースを削除する。エンコードされた日本語をデコードする。}
  spec.homepage      = "http://www.yocto-inc.com/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_dependency 'charwidth'
end
