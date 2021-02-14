# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def default_pods
 	pod 'RxSwift', '6.0.0'
    pod 'RxCocoa', '6.0.0'

end

target 'movies' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for movies
default_pods

  target 'moviesTests' do
    inherit! :search_paths
    # Pods for testing
default_pods
  end

  target 'moviesUITests' do
    # Pods for testing
default_pods
  end

end
