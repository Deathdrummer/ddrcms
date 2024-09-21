<div class="material">
    <img class="material__image" src="{{base_url('public/filemanager/__mini__/'~image)}}" openmaterial="{{title}}|{{base_url('public/filemanager/'~image)}}" alt="{{alt}}">
    <div class="material__caption">
        <h4 class="material__title" openmaterial="{{title}}|{{base_url('public/filemanager/'~image)}}">{{title}}</h4>
        <div class="material__desc" materialdesc="{{description}}">{{description|trimstring(150, '...')}}</div>
    </div>
</div>