describe HashedRecord do
  subject(:hashed) { described_class.new(records) }
  let(:user1) { OpenStruct.new(id: 1, group_id: 10, region_id: 15)}
  let(:user11) { OpenStruct.new(id: 2, group_id: 10, region_id: 12)}
  let(:user2) { OpenStruct.new(id: 5, group_id: 50, region_id: 12)}
  let(:records) { [user1, user11, user2] }

  it 'return collection without filtering' do
    expect(hashed.to_a).to eq([user1, user11, user2])
  end

  it 'filter by id' do
    expect(hashed.where(id: 1).to_a).to eq([user1])
  end

  it 'select 2 records by group_id' do
    expect(hashed.where(group_id: 10).to_a).to eq([user1, user11])
  end

  it 'filter by ids' do
    expect(hashed.where(id: [1, 5]).to_a).to eq([user1, user2])
  end

  context 'with intersection' do
    it 'returns intersection only' do
      expect(hashed.where(group_id: [10], region_id: 12).to_a).to eq([user11])
    end
  end

  context 'with multiple where' do
    it 'returns intersection only' do
      expect(hashed.where(group_id: 10).where(region_id: 12).to_a).to eq([user11])
    end
  end

  context 'with excluding conditions' do
    it 'exclude' do
      expect(hashed.not(region_id: 12).to_a).to eq([user1])
    end

    it 'chain exclude' do
      expect(hashed.where(group_id: 10).not(region_id: 12).to_a).to eq([user1])
    end
  end

  it 'behave as enumerable' do
    expect(hashed.where(group_id: 10).map(&:id)).to eq([1, 2])
  end

  it 'does not lost duplicates' do
    hashed = described_class.new([user1, user1])
    expect(hashed.where(group_id: 10).to_a).to eq([user1, user1])
  end
end
