function[f,fft_data_plot,fft_iapp_plot]= fft_analysis(test_time,test_data,iapp)
        
        fft_size=size(test_time,1);% get the column size in time domain
        fft_data=20*log10(abs(fft(test_data,fft_size)));% get the amplitude in dB
        fs=1/(test_time(2)-test_time(1));
        f=fs*(0:fix(fft_size/2))/fft_size;
        % To obtain the correct amplitude mulitply it by 2/N
        factor=2/size(test_time,1);
        fft_data_plot=fft_data(1:(fix(fft_size/2)+1)).*factor;
        fft_iapp=20*log10(abs(fft(iapp,fft_size)));% get the amplitude in dB
        fft_iapp_plot=fft_iapp(1:(fix(fft_size/2)+1)).*factor;