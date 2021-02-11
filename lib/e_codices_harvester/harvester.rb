# frozen_string_literal: true
require "faraday"
require "json"
require "pry"


module ECodicesHarvester
  class Harvester
    attr_accessor :uri
    def initialize(args)
      @uri = URI(args[:uri])
      @manifests = nil
      @collections = nil
      @base_dir = "/tmp"
    end

    def collections
      return @collections unless @collections.nil?
      @collections = Set.new
      fetch_collections(uri)
      return @collections
    end

    def manifests
      return @manifests unless @manifests.nil?
      @manifests = Set.new
      collections.each { |c| fetch_manifests(c) }
      @manifests
    end

    def fetch_manifests(uri)
      raise "no uri: |#{uri}|" unless uri
      puts uri
      response = Faraday.get(uri)
      resource = JSON.parse(response.body)
      if resource.keys.include? 'manifests'
        resource['manifests'].each do |m|
          @manifests << URI(m['@id'])
        end
      end
    end

    def fetch_manifests_old(uri)
      raise "no uri: |#{uri}|" unless uri
      puts uri
      response = Faraday.get(uri)
      resource = JSON.parse(response.body)
      if resource.keys.include? 'manifests'
        resource['manifests'].collect { |m| URI(m['@id']) }
      end
    end
    
    def fetch_collections_old(uri, accumulator = [])
#      binding.pry
      response = Faraday.get(uri)
      # TODO handle errors
      resource = JSON.parse(response.body)
      if resource['@type'] == 'sc:Collection'
        accumulator.push URI(resource['@id'])
        if resource.keys.include? 'collections'
          accumulator += resource['collections'].collect { |c|
            fetch_collections(URI(c['@id']), accumulator)
          }
        end
      end
      accumulator
    end

    def fetch_collections(uri)
#      binding.pry
      response = Faraday.get(uri)
      # TODO handle errors
      resource = JSON.parse(response.body)
      if resource['@type'] == 'sc:Collection'
        @collections << URI(resource['@id'])
        if resource.keys.include? 'collections'
          resource['collections'].map { |c|
            fetch_collections(URI(c['@id']))
          }
        end
      end
    end

    def list_collections
      collections.each { |c| puts c }
    end

    def list_manifests
      manifests.each { |m| puts m }
    end

    def download_collections
      collections.each do |uri|
        response = Faraday.get(uri)
        path = uri.path.split('/')
        fname = path.pop
        download_path = File.join(@base_dir, path)
        FileUtils.mkdir_p(download_path)
        File.open(File.join(download_path, fname), 'w') do |f|
          f.write(response.body)
        end
      end
    end

    def download_manifests
      manifests.each do |uri|
        response = Faraday.get(uri)
        path = uri.path.split('/')
        fname = path.pop
        download_path = File.join(@base_dir, path)
        FileUtils.mkdir_p(download_path)
        File.open(File.join(download_path, fname), 'w') do |f|
          f.write(response.body)
        end
      end
    end
  end
end
