categories = {'blackswan', 'bmx-trees', 'breakdance', 'camel', 'car-roundabout', ...
    'car-shadow', 'cows', 'dance-twirl', 'dog', 'drift-chicane', ...
    'drift-straight', 'goat', 'horsejump-high', 'kite-surf', 'libby', ...
    'motocross-jump', 'paragliding-launch', 'parkour', 'scooter-black', 'soapbox' };


for c = 1:length(categories)
% for c = 13
    category = categories{c};    
    
    imgPath = fullfile('DAVIS/JPEGImages/480p/', category);
    rstPath = fullfile('DAVIS/Results_osvos/', category);
    annPath = fullfile('DAVIS/Annotations/480p/', category);

    imgFiles = dir( fullfile(imgPath, '/*.jpg'));
    rstFiles = dir( fullfile(rstPath, '/*.png'));
    annFiles = dir( fullfile(annPath, '/*.png'));

    assert( length(imgFiles) == length(rstFiles) );
    
    vid = VideoWriter( ['videos/', category '.mp4']);
    vid.FrameRate = 10;
    open(vid);       
    
%     figure(1); clf;
    for ii = 1:length(imgFiles)
        mask = imread( fullfile( rstPath, rstFiles(ii).name ) );
        mask_pred = repmat( mask, [1 1 3] );
        
        img_result = imread( fullfile( imgPath, imgFiles(ii).name ) );
        img_result(:,:,1) = min(255, img_result(:,:,1) + 150*uint8(im2single(mask)>0.757) );
        
        ann = imread( fullfile( annPath, annFiles(ii).name ) );
        img_gt = imread( fullfile( imgPath, imgFiles(ii).name ) );
        img_gt(:,:,2) = min(255, img_gt(:,:,2) + 150*uint8(im2single(ann)>0.757) );
        
        [h, w] = size(mask);
        pad = 255 * ones( h, 20, 3);
        
        frame = [ mask_pred, pad, img_result, pad, img_gt ];
        
        writeVideo(vid, frame);
%         subplot(131);
%         mask = im2single( imread( fullfile( rstPath, rstFiles(ii).name ) ) );        
%         imagesc( mask, [0,1] );
%         axis equal;
%         axis off;                      
%         
%         img = imread( fullfile( imgPath, imgFiles(ii).name ) );
%         mask = imread( fullfile( rstPath, rstFiles(ii).name ) );
% 
% %         img(:,:,1) = min(255, img(:,:,1) + 100*uint8(im2single(mask)>0.757) );
%         img(:,:,2) = min(255, img(:,:,2) + 150*uint8(im2single(mask)>0.757) );
% 
%         subplot(132);
%         imshow( img );
%         title('Result');
% 
%         img = imread( fullfile( imgPath, imgFiles(ii).name ) );
%         mask = imread( fullfile( annPath, annFiles(ii).name ) );
% 
% %         img(:,:,1) = min(255, img(:,:,1) + 100*uint8(im2single(mask)>0.757) );
%         img(:,:,2) = min(255, img(:,:,2) + 150*uint8(im2single(mask)>0.757) );
% 
%         subplot(133);
%         imshow( img );
%         title('GT');                
% 
%         pause(0.1);
    end
    
    close(vid);
end