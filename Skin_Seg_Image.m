function img_out = Skin_Seg_Image(A,mean_cr,mean_cb,sigma_cr,sigma_cb)

    YcBcRMap = rgb2ycbcr(A);
    %Y_comp = YcBcRMap(:,:,1); % Don't need this
    cB_comp = YcBcRMap(:,:,2);
    cR_comp = YcBcRMap(:,:,3);
    clear YcBcRMap A fileName

    %% Skin color segmentation
    S_1 = (cR_comp > (mean_cr-sigma_cr)) & (cR_comp < (mean_cr+sigma_cr));
    S_2 = (cB_comp > (mean_cb-sigma_cb)) & (cB_comp < (mean_cb+sigma_cb));
    img_out = (S_1 & S_2);
    

end



