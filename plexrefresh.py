from plexapi.server import PlexServer



baseurl = 'INSERT PLEX SERVER IP AND PORT'
token = 'INSERT PLEX TOKEN'
plex = PlexServer(baseurl, token)

plex.library.section('Music').update()