class CogSocEnvSpace < Formula
  desc "Cognitive-social environment space simulator"
  homepage "https://github.com/jcanell4/cog_soc_env_space"
  url "https://github.com/jcanell4/cog_soc_env_space/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "44b6f9afddd479516579b59c4bfb0ab61029f48dadc89556f0f48a546da8b1ce"
  license "MIT"

  depends_on "cmake" => :build

  depends_on "raylib"
  depends_on "nlohmann-json"
  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_RAYLIB_VIEWER=ON"
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
