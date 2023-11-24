Pod::Spec.new do |spec|

  spec.name         = "Composure"
  spec.version      = "1.2.2"
  spec.summary      = "Create complex layouts with UICollectionView using compositional layout."
  spec.description  = <<-DESC
  Composure tremendously simplifies Apple's Compositional Layout especially for vertically scrolling views. Choose one of the available layout options to present your forms in less than 5 minutes. 
                   DESC
  spec.homepage     = "https://github.com/eclypse-tms/Composure"
  spec.screenshots  = "https://raw.githubusercontent.com/eclypse-tms/Composure/main/assets/preview-portrait.jpg", "https://raw.githubusercontent.com/eclypse-tms/Composure/main/assets/preview-landscape.jpg"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Deniz Nessa" => "deniz@eclypse.io" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/eclypse-tms/Composure.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.swift"
  spec.swift_versions  = ["5.3", "5.4", "5.5", "5.6", "5.7"]

end
