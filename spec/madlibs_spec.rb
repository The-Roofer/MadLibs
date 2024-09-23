require 'madlibs'

describe Madlibs do
  describe ".GetWords" do
    it "will return [book] for this story" do
        story = "The book {book} is about a duck"
        madlibs_worker = Madlibs.new
        words = madlibs_worker.GetWords(story)
        expect(words).to eql(["book"])
    end
    it "will return [city, job] for this story" do
        story = "I work in {city} as a {job}."
        madlibs_worker = Madlibs.new
        words = madlibs_worker.GetWords(story)
        expect(words).to eql(["city", "job"])
    end
    it "will return a very long result for this story" do
        story = "I remember when {a very specific memory from gradeschool} and I'll never get over it."
        madlibs_worker = Madlibs.new
        words = madlibs_worker.GetWords(story)
        expect(words).to eql(["a very specific memory from gradeschool"])
    end
  end
end