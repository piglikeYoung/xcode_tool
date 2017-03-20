fastlane_version "2.19.3"

default_platform :ios

platform :ios do
  before_all do

    cocoapods
    
  end

  lane :createDebugIPA do
    ipa_path = "/Users/pikeyoung/Documents/" + Time.now.strftime("%Y-%m-%d") + "/Debug/"
    ipa_name = "Livestar"
    gym(
      scheme: "Livestar.tv",
      output_name: ipa_name,      # 输出的IPA名称
      silent: true,               # 隐藏不必要的信息
      clean: true,                # 在构建前先clean
      configuration: "Debug",     # 指定要打包的配置名
      export_method: 'ad-hoc',    # 指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
      output_directory: ipa_path  # IPA输出目录
    )
  end

  lane :createReleaseIPA do
    ipa_path = "/Users/pikeyoung/Documents/" + Time.now.strftime("%Y-%m-%d") + "/Release/"
    ipa_name = "Livestar"
    gym(
      scheme: "Livestar.tv",
      output_name: ipa_name,      # 输出的IPA名称
      silent: true,               # 隐藏不必要的信息
      clean: true,                # 在构建前先clean
      configuration: "Release",     # 指定要打包的配置名
      export_method: 'ad-hoc',    # 指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
      output_directory: ipa_path  # IPA输出目录
    )
  end

  lane :uploadDebugIPA do
    ipa_path = "/Users/pikeyoung/Documents/" + Time.now.strftime("%Y-%m-%d") + "/Debug/Livestar.ipa"
    upload_app_to_bugly(
      file_path: ipa_path,
      app_key: "tlR6RA2vwUwIrhDe",
      app_id: "900048096",
      pid: "2",
      title: "iOS-Debug" + Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      desc: "内部测试,请勿外泄"
    )
  end

  lane :uploadReleaseIPA do
    ipa_path = "/Users/pikeyoung/Documents/" + Time.now.strftime("%Y-%m-%d") + "/Release/Livestar.ipa"
    upload_app_to_bugly(
      file_path: ipa_path,
      app_key: "tlR6RA2vwUwIrhDe",
      app_id: "900048096",
      pid: "2",
      title: "iOS-Release" + Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      desc: "内部测试,请勿外泄"
    )
  end

  # You can define as many lanes as you want

  after_all do |lane|
    # slack(
    #   message: "Successfully deployed new App Update."
    # )
  end

  error do |lane, exception|
    # slack(
    #   message: exception.message,
    #   success: false
    # )
  end
end
