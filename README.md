# Altiverb6_Wav

Lossless converter for Altiverb 6 impulse-response libraries (IR Installer CDs) and Altiverb 7
`.irbulk` files to plain WAV files for generic convolution apps such as Convology.

Most Altiverb 6 channel files (`.1 .2 .3 .4 .L .R .C .Ls .Rs`) are not raw PCM but Audio Ease's own
compressed format (`cir2` and two older variants): a fixed 3rd-order predictor with residuals packed
in small blocks. `Alti.py` decodes them exactly (each file is checked against the encoder's rules),
applies the per-channel gains and sample rates from `info.iri`, and writes 24-bit PCM WAVs in a
mirrored folder tree. See the docstring at the top of `Alti.py` for the format details.

    pip install numpy soundfile
    python3 Alti.py -o "<output folder>"          # converts the IR Installer folders next to this repo
    python3 Alti.py <items folder> -o "<output>"   # or any folder of Altiverb IRs
    python3 Alti.py <file.irbulk> -o "<output>"    # an Altiverb 7 IR bulk file

Options: `--raw` (no info.iri gains), `--join` (one multichannel file per IR instead of one mono
file per channel), `--skip-surround` (drop the surround sets, more than four channels per IR),
`--no-pictures` (write only the WAVs, not the pictures), `--peak <dBFS>` (level of the loudest
channel per IR folder, 0 dBFS or below, default -0.1). There is no output format option: the WAVs
are always 24-bit PCM.

By default each IR channel becomes its own mono `<name>.wav`. With `--join` each IR becomes one
file: a stereo pair becomes a stereo file, a true stereo set becomes one four channel file in
LL, LR, RL, RR order (the layout a convolution plug-in expects for quad true stereo), and a
surround set becomes one four channel file in the standard L, R, Ls, Rs order. Channels shorter
than the longest are padded with silence. IRs whose channel order cannot be derived from their
names, the eight and sixteen channel surround sets in particular, are left as separate mono files
and listed in the log. The order comes from the channel names, which were checked against the
libraries: the same audio is stored as `...1` in one folder and `...L` in another, so the numbers
are the standard ones (1 = L, 2 = R, 3 = Ls, 4 = Rs).

## Pictures

Pictures are copied once each, into the folder the library keeps them in, and nothing is
converted: the published libraries are JPEG apart from two PNGs, so a picture is a byte for byte
copy. They are not duplicated into the IR folders, and there is no `00 DEFAULT PICTURES` folder.
A record that is not a picture (the libraries hold a placeholder of zeros and a movie named
`.jpg`) is skipped and reported. `--no-pictures` skips them entirely.

## Interface (PyQt5)

    pip install PyQt5 numpy soundfile pillow
    python3 AltiGUI.py            # or double-click AltiGUI.command

Choose a source folder (Altiverb 6 IR folders and/or Altiverb 7 `.irbulk` files anywhere inside
it) and an output folder, then Convert. Same conversion and options as `Alti.py`, with a progress
bar, a Stop button and the log in the window.
