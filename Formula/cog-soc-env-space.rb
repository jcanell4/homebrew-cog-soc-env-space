class CogSocEnvSpace < Formula
  desc "Cognitive-social environment space simulator"
  homepage "https://github.com/jcanell4/cog_soc_env_space"
  url "https://github.com/jcanell4/cog_soc_env_space/archive/refs/tags/v0.0.1.tar.gz"
  version "0.0.1"
  sha256 "177924ee07337df46cec74ba8b5b2dc1ea8f13eb1f5597ec9ebcff781282b7f7"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    bin.install "build/cog_soc_env_space"
    bin.install "build/cog_soc_env_space_viewer" if (buildpath/"build/cog_soc_env_space_viewer").exist?

    pkgshare.install "config/simulation.example.json"
    pkgshare.install "config/niche.example.000.json"
  end

  test do
    (testpath/"sim.json").write <<~JSON
      {
        "version": 1,
        "random_seed": 42,
        "total_cycles": 1,
        "noise_stddev": 0.0,
        "environment_path": "#{pkgshare}/niche.example.000.json"
      }
    JSON

    system bin/"cog_soc_env_space", "--config", testpath/"sim.json",
           "--environment", "#{pkgshare}/niche.example.000.json"
    assert_predicate (testpath/"output/simulation.json"), :exist?
  end
end
