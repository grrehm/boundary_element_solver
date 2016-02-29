B=define_primary_BPM;
B=calculate_induced_charge(B);
B=find_button_indices(B);
%visualise_potential_and_charge(B);
B=raster_beam(B,5,.1);
B=convert_abcd2xy(B);
B=find_apply_scalefactor(B);
plot_rastered(B);
sensitivity_analysis(B);
% now put together an ABCD vector as we would get from a TbT BPM record
abcd=[B.a(:) B.b(:) B.c(:) B.d(:)].';
% and invert this back to XY
tic;xy=abcd2xy(abcd,B);toc
hold on
plot(xy(1,:),xy(2,:),'o');
