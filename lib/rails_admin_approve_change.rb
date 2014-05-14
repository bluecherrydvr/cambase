module RailsAdmin
  module Extensions
    module PaperTrail
      class VersionProxy
        def id
          @version.id
        end

        def changes
          @changes = @version.changeset.to_a.collect {|c| c[0] + " = " + c[1][1].to_s}.join(", \n")
        end
      end
    end
  end
end
