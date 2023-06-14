# frozen_string_literal: true

class ResendStoredBlobDataJob < ApplicationJob
  # Resending the blob data will trigger a malware scan.
  def perform(batch_size: 1000)
    return unless FeatureFlags::FeatureFlag.active?(:malware_scan)

    Upload
      .where(malware_scan_result: "pending")
      .limit(batch_size)
      .find_each do |upload|
        sleep(2) # Avoid rate limiting
        Malware::ResendStoredBlobData.new(upload:).call
      end
  end
end
