class TermKind < ClassyEnum::Base
end

class TermKind::Mandatory < TermKind
end

class TermKind::Optional < TermKind
end
