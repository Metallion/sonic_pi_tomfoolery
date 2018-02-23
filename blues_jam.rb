use_bpm 100
key = note(:G3)

in_thread(name: :conductor) do
  loop do
    set :key, key
    sleep 4

    # Some times play the 4chord on the second bar
    if rand(0..1) == 0
      set :key, key + 5
    else
      set :key, key
    end
    sleep 4

    2.times do
      set :key, key
      sleep 4
    end

    2.times do
      set :key, key + 5
      sleep 4
    end
    2.times do
      set :key, key
      sleep 4
    end

    set :key, key + 7
    sleep 4
    set :key, key + 5
    sleep 4
    set :key, key
    sleep 4
    set :key, key + 7
    sleep 4
  end
end

in_thread(name: :drums) do
  loop do
    sample :drum_bass_soft
    sample :drum_cymbal_closed
    sleep 2/3.0
    sample :drum_cymbal_closed
    sleep 1/3.0
    sample :drum_snare_soft
    sample :drum_cymbal_closed
    sleep 2/3.0
    sample :drum_cymbal_closed
    sleep 1/3.0
  end
end

in_thread(name: :bass) do
  use_synth :blade
  @bass_root = key

  def simple_shuffle_bass(notes)
    4.times do
      note = notes.tick
      play note
      sleep 2/3.0
      play note
      sleep 1/3.0
    end
  end

  def major_chord_arpeggio
    simple_shuffle_bass (ring @bass_root, @bass_root + 4, @bass_root + 7, @bass_root + 4)
    @bass_root = sync :key
  end

  def walkup_to_4th
    simple_shuffle_bass (ring @bass_root, @bass_root + 1, @bass_root + 2, @bass_root + 3)
    @bass_root = sync :key
  end

  def walkup_to_5th
    simple_shuffle_bass (ring @bass_root, @bass_root + 4, @bass_root + 5, @bass_root + 6)
    @bass_root = sync :key
  end

  loop do
    3.times { major_chord_arpeggio }

    if rand(0..1) == 0
      major_chord_arpeggio
    else
      walkup_to_4th
    end

    6.times { major_chord_arpeggio }

    walkup_to_5th
    major_chord_arpeggio
  end
end

in_thread(name: :guitar) do
  use_synth :pluck
  root = key

  loop do
    play chord(root, :major7), amp: 1.5
    sleep 1
    sleep 2/3.0
    play chord(root, :major7), amp: 1.5
    sleep 1/3.0
    play chord(root, :major7), amp: 1.5
    sleep 2/3.0
    play chord(root, :major7), amp: 1.5
    sleep 1/3.0
    sleep 1
    root = sync :key
  end
end
