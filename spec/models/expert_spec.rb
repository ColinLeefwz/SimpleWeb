require 'spec_helper'

describe Expert do
  helper_objects

  describe ".sessions_with_draft" do
    it "returns the expert's all sessions with draft" do
      [session_find, session_draft_map, session_map, session_intro]
      expect(alex.sessions_with_draft.count).to eq 3
    end

    it "shows draft sessions before non-draft ones" do
      [session_find, session_draft_map, session_map]
      expect(alex.sessions_with_draft).to eq [session_draft_map, session_map, session_find]
    end 

    it "returns [] if epxert has no sessions" do
      expect(alex.sessions_with_draft.count).to eq 0
      expect(alex.sessions_with_draft).to eq []
    end
  end
end
